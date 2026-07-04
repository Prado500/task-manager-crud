from typing import List, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.database import get_db
from app.repositories.task_repository import TaskRepository
from app.services.task_service import TaskService
from app.schemas.task import TaskCreate, TaskUpdate, TaskResponse
from app.models.task import TaskStatus, TaskPriority

router = APIRouter(prefix="/tasks", tags=["Tasks"])


def get_task_service(db: AsyncSession = Depends(get_db)) -> TaskService:
    """
    Dependency injection factory to assemble the TaskService.
    Instantiates the repository with the active database session and passes it to the service.
    """
    repository = TaskRepository(db)
    return TaskService(repository)


@router.post("/", response_model=TaskResponse, status_code=status.HTTP_201_CREATED)
async def create_task(
        task_in: TaskCreate,
        service: TaskService = Depends(get_task_service)
):
    """
    Creates a new task in the system.

    Args:
        task_in (TaskCreate): The payload containing the task details.
        service (TaskService): The injected business logic service.

    Returns:
        TaskResponse: The created task data serialized for the client.
    """
    return await service.create_task(task_in)


@router.get("/", response_model=List[TaskResponse], status_code=status.HTTP_200_OK)
async def list_tasks(
        status_filter: Optional[TaskStatus] = Query(None, alias="status", description="Filter tasks by status"),
        priority_filter: Optional[TaskPriority] = Query(None, alias="priority", description="Filter tasks by priority"),
        service: TaskService = Depends(get_task_service)
):
    """
    Retrieves a list of all tasks. Supports optional filtering by status and priority.

    Args:
        status_filter (Optional[TaskStatus]): Query parameter to filter by task status.
        priority_filter (Optional[TaskPriority]): Query parameter to filter by task priority.
        service (TaskService): The injected business logic service.

    Returns:
        List[TaskResponse]: A list of tasks matching the applied filters.
    """
    return await service.list_tasks(status_filter=status_filter, priority_filter=priority_filter)


@router.put("/{task_id}", response_model=TaskResponse, status_code=status.HTTP_200_OK)
async def update_task(
        task_id: str,
        task_in: TaskUpdate,
        service: TaskService = Depends(get_task_service)
):
    """
    Partially updates an existing task.

    Args:
        task_id (str): The unique identifier of the task in the URL path.
        task_in (TaskUpdate): The payload containing the fields to update.
        service (TaskService): The injected business logic service.

    Returns:
        TaskResponse: The updated task data serialized for the client.
    """
    return await service.update_task(task_id, task_in)


@router.delete("/{task_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_task(
        task_id: str,
        service: TaskService = Depends(get_task_service)
):
    """
    Permanently deletes a task from the system.

    Args:
        task_id (str): The unique identifier of the task in the URL path.
        service (TaskService): The injected business logic service.
    """
    await service.delete_task(task_id)