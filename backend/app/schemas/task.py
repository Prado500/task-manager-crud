from pydantic import BaseModel, Field, EmailStr
from typing import Optional
from datetime import date
from app.models.task import TaskPriority, TaskStatus

class TaskBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=150, description="Identificador principal y resumen breve")
    description: Optional[str] = Field(None, max_length=1000, description="Detalle completo de la tarea")
    due_date: date = Field(..., description="Fecha límite temporal (ISO 8601 YYYY-MM-DD)")
    priority: TaskPriority = Field(default=TaskPriority.MEDIUM)
    status: TaskStatus = Field(default=TaskStatus.PENDING)
    origin_framework: str = Field(default="flutter")
    user_email: EmailStr = Field(..., description="Email proporcionado por el aspirante")

class TaskCreate(TaskBase):
    # During the creation of a task, the client is allowed to provide a temporary ID; otherwise the DB will assign a UUID.
    task_id: Optional[str] = Field(None, max_length=36)

class TaskUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=150)
    description: Optional[str] = Field(None, max_length=1000)
    due_date: Optional[date] = None
    priority: Optional[TaskPriority] = None
    status: Optional[TaskStatus] = None

class TaskResponse(TaskBase):
    task_id: str

    class Config:
        from_attributes = True