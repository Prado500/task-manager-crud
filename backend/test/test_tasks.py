import pytest
from httpx import AsyncClient, ASGITransport
from unittest.mock import AsyncMock
from datetime import date

from app.main import app
from app.api.v1.tasks import get_task_service
from app.models.task import TaskPriority, TaskStatus
from app.schemas.task import TaskResponse

# Mock data strictly adhering to the Pydantic schema
mock_task_response = TaskResponse(
    task_id="abc-123-xyz",
    title="Test Task for Supervisa",
    description="This is an automated test task.",
    due_date=date(2026, 7, 4),
    priority=TaskPriority.HIGH,
    status=TaskStatus.PENDING,
    origin_framework="flutter",
    user_email="david@supervisa.com"
)

@pytest.fixture
def mock_service():
    """Generates an AsyncMock for the TaskService to isolate the database layer."""
    service = AsyncMock()
    service.create_task.return_value = mock_task_response
    service.list_tasks.return_value = [mock_task_response]
    service.update_task.return_value = mock_task_response
    service.delete_task.return_value = None
    return service

@pytest.fixture
def override_dependency(mock_service):
    """Overrides the FastAPI dependency injection graph for testing."""
    app.dependency_overrides[get_task_service] = lambda: mock_service
    yield
    app.dependency_overrides.clear()

@pytest.mark.asyncio
async def test_create_task(override_dependency):
    """Verifies that the POST /tasks/ endpoint successfully processes payloads."""
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        response = await ac.post(
            "/api/v1/tasks/",
            json={
                "title": "Test Task for Supervisa",
                "description": "This is an automated test task.",
                "due_date": "2026-07-04",
                "priority": "high",
                "status": "pending",
                "origin_framework": "flutter",
                "user_email": "david@supervisa.com"
            }
        )
    assert response.status_code == 201
    assert response.json()["task_id"] == "abc-123-xyz"

@pytest.mark.asyncio
async def test_list_tasks(override_dependency):
    """Verifies that the GET /tasks/ endpoint returns a list of TaskResponses."""
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        response = await ac.get("/api/v1/tasks/")

    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) == 1
    assert data[0]["title"] == "Test Task for Supervisa"

@pytest.mark.asyncio
async def test_update_task(override_dependency):
    """Verifies that the PUT /tasks/{task_id} endpoint handles partial updates."""
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        response = await ac.put(
            "/api/v1/tasks/abc-123-xyz",
            json={"status": "in_progress"}
        )
    assert response.status_code == 200
    assert response.json()["task_id"] == "abc-123-xyz"

@pytest.mark.asyncio
async def test_delete_task(override_dependency):
    """Verifies that the DELETE /tasks/{task_id} endpoint executes successfully."""
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        response = await ac.delete("/api/v1/tasks/abc-123-xyz")

    assert response.status_code == 204