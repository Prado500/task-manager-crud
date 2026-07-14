import httpx
from fastapi import HTTPException, status
from typing import Dict, Any

class PokemonApiClient:
    """
    HTTP Client acting as a repository for the external PokeAPI.
    Isolates network operations from the business logic layer.
    """
    BASE_URL = "https://pokeapi.co/api/v2/pokemon"

    async def get_pokemon_data(self, pokemon_id: int) -> Dict[str, Any]:
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(f"{self.BASE_URL}/{pokemon_id}")
                if response.status_code != 200:
                    raise HTTPException(
                        status_code=status.HTTP_502_BAD_GATEWAY,
                        detail=f"Error fetching Pokemon {pokemon_id} from external API"
                    )
                return response.json()
            except httpx.RequestError as e:
                raise HTTPException(
                    status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                    detail="PokeAPI is currently unreachable."
                )