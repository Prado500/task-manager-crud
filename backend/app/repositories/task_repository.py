from typing import Sequence, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.task import TaskEntity, TaskStatus, TaskPriority

class TaskRepository:
    """
    Repository handling all database operations for the Task entity.
    Isolates the SQLAlchemy implementation from the business logic layer.
    """

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, task: TaskEntity) -> TaskEntity:
        """
        Persists a new Task record in the database.

        Args:
            task (TaskEntity): The populated task model instance.

        Returns:
            TaskEntity: The saved task with refreshed database state.
        """
        self.session.add(task)
        await self.session.commit()
        await self.session.refresh(task)
        return task

    async def list_tasks(
            self,
            status: Optional[TaskStatus] = None,
            priority: Optional[TaskPriority] = None
    ) -> Sequence[TaskEntity]:
        """
        Retrieves a list of tasks, optionally applying dynamic logical AND filters.

        Args:
            status (Optional[TaskStatus]): Filter tasks by their current status.
            priority (Optional[TaskPriority]): Filter tasks by their urgency level.

        Returns:
            Sequence[TaskEntity]: A list of task entities matching the criteria.
        """
        query = select(TaskEntity)

        if status:
            query = query.where(TaskEntity.status == status)
        if priority:
            query = query.where(TaskEntity.priority == priority)

        result = await self.session.execute(query)
        return result.scalars().all()

    async def get_by_id(self, task_id: str) -> Optional[TaskEntity]:
        """
        Retrieves a single task by its unique identifier.

        Args:
            task_id (str): The surrogate key of the task.

        Returns:
            Optional[TaskEntity]: The task entity if found, otherwise None.
        """
        query = select(TaskEntity).where(TaskEntity.task_id == task_id)
        result = await self.session.execute(query)
        return result.scalars().first()

    async def update(self, task: TaskEntity) -> TaskEntity:
        """
        Commits changes made to an existing task entity.

        Args:
            task (TaskEntity): The task instance with updated attributes.

        Returns:
            TaskEntity: The updated task with refreshed database state.
        """
        await self.session.commit()
        await self.session.refresh(task)
        return task

    async def delete(self, task: TaskEntity) -> None:
        """
        Permanently removes a task from the database.

        Args:
            task (TaskEntity): The task instance to be deleted.
        """
        await self.session.delete(task)
        await self.session.commit()