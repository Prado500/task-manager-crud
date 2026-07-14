from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database.database import engine, Base
from app.api.v1.tasks import router as tasks_router
from app.api.v1.pokemon import router as pokemon_router

@asynccontextmanager
async def lifespan(_app: FastAPI):
    """
    Manages the application lifecycle events.
    Executes database table creation on startup and connection teardown on shutdown.
    """

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    yield


    await engine.dispose()



app = FastAPI(
    title="Supervisa Task Management API",
    description="RESTful API for the technical admission test CRUD operations.",
    version="0.1.0",
    lifespan=lifespan
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(tasks_router, prefix="/api/v1")
app.include_router(pokemon_router, prefix="/api/v1")
