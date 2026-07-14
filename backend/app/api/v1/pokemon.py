from typing import List
from fastapi import APIRouter, Depends, status
from app.services.pokemon_service import PokemonService
from app.repositories.pokemon_client import PokemonApiClient
from app.schemas.pokemon import PokemonResponse

router = APIRouter(prefix="/pokemon", tags=["Pokemon"])

def get_pokemon_service() -> PokemonService:
    """
    Dependency injection factory to assemble the PokemonService.
    """
    client = PokemonApiClient()
    return PokemonService(client)


@router.get("/", response_model=List[PokemonResponse], status_code=status.HTTP_200_OK)
async def list_top_pokemon(service: PokemonService = Depends(get_pokemon_service)):
    """
    Retrieves information for 10 Pokemon from the external PokeAPI.
    
    Args:
        service (PokemonService): The injected business logic service.
        
    Returns:
        List[PokemonResponse]: A mapped list of 10 Pokemon.
    """
    return await service.get_top_10_pokemon()