from typing import Sequence, Optional
from fastapi import HTTPException, status
from app.repositories.task_repository import TaskRepository
from app.schemas.task import TaskCreate, TaskUpdate
from app.models.task import TaskEntity, TaskStatus, TaskPriority

class TaskService:
    """
    Business logic layer for the Task entity.
    Orchestrates data transfer objects (DTOs), business rules, and repository persistence.
    """

    def __init__(self, repository: TaskRepository):
        self.repository = repository

    async def create_task(self, task_data: TaskCreate) -> TaskEntity:
        """
        Processes validated DTO data to create a new task in the system.

        Args:
            task_data (TaskCreate): The validated input data from the client.

        Returns:
            TaskEntity: The newly persisted task entity.
        """
        # Convert Pydantic schema directly into a SQLAlchemy model
        task = TaskEntity(**task_data.model_dump())
        return await self.repository.create(task)

    async def list_tasks(
            self,
            status_filter: Optional[TaskStatus] = None,
            priority_filter: Optional[TaskPriority] = None
    ) -> Sequence[TaskEntity]:
        """
        Retrieves tasks based on optional status and priority filters.

        Args:
            status_filter (Optional[TaskStatus]): The exact status to filter by.
            priority_filter (Optional[TaskPriority]): The exact priority to filter by.

        Returns:
            Sequence[TaskEntity]: The list of tasks matching the criteria.
        """
        return await self.repository.list_tasks(status=status_filter, priority=priority_filter)

    async def get_task_or_404(self, task_id: str) -> TaskEntity:
        """
        Retrieves a task by its ID or raises an HTTP 404 exception if not found.
        Acts as a strict guard for update and delete operations.

        Args:
            task_id (str): The surrogate key of the target task.

        Raises:
            HTTPException: If the task_id does not exist in the database.

        Returns:
            TaskEntity: The retrieved task.
        """
        task = await self.repository.get_by_id(task_id)
        if not task:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Task with id '{task_id}' not found."
            )
        return task

    async def update_task(self, task_id: str, task_data: TaskUpdate) -> TaskEntity:
        """
        Validates existence and applies partial updates to a task.

        Args:
            task_id (str): The unique identifier of the task to update.
            task_data (TaskUpdate): The DTO containing the fields to modify.

        Returns:
            TaskEntity: The updated task entity.
        """
        task = await self.get_task_or_404(task_id)

        # Extract only the fields explicitly provided in the request
        update_data = task_data.model_dump(exclude_unset=True)

        for key, value in update_data.items():
            setattr(task, key, value)

        return await self.repository.update(task)

    async def delete_task(self, task_id: str) -> None:
        """
        Validates existence and permanently removes a task from the system.

        Args:
            task_id (str): The unique identifier of the task to delete.
        """
        task = await self.get_task_or_404(task_id)
        await self.repository.delete(task)