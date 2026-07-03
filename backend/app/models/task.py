import uuid
from sqlalchemy import Column, String, Date, Enum as SQLEnum, Text
from sqlalchemy.orm import declarative_base
import enum

Base = declarative_base()

class TaskPriority(str, enum.Enum):
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"

class TaskStatus(str, enum.Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"

class TaskEntity(Base):
    __tablename__ = "tasks"

    # Using String instead of strict UUID to support temporary IDs like "abc123" as per documentation requirements.
    task_id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), index=True)

    title = Column(String(150), unique=True, nullable=False, index=True)
    description = Column(String(1000), nullable=True)
    due_date = Column(Date, nullable=False)

    priority = Column(SQLEnum(TaskPriority), nullable=False, default=TaskPriority.MEDIUM)
    status = Column(SQLEnum(TaskStatus), nullable=False, default=TaskStatus.PENDING)

    origin_framework = Column(String(50), nullable=False, default="flutter")
    user_email = Column(String(150), nullable=False)