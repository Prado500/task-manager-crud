import asyncio
from typing import List
from app.repositories.pokemon_client import PokemonApiClient
from app.schemas.pokemon import PokemonResponse

class PokemonService:
    """
    Business logic layer for Pokemon data.
    Orchestrates external API calls and data transformation.
    """
    def __init__(self, api_client: PokemonApiClient):
        self.api_client = api_client

    async def get_top_10_pokemon(self) -> List[PokemonResponse]:
        """
        Fetches data for 10 Pokemon concurrently and maps them to the DTO.
        """
        # Execute 10 non-blocking HTTP requests concurrently
        tasks = [self.api_client.get_pokemon_data(i) for i in range(1, 11)]
        results = await asyncio.gather(*tasks)

        pokemon_list = []
        for data in results:
            # Extract types safely
            types = [t["type"]["name"] for t in data.get("types", [])]
            
            # Extract official artwork safely
            sprites = data.get("sprites", {})
            other_sprites = sprites.get("other", {})
            artwork = other_sprites.get("official-artwork", {}).get("front_default")
            
            # Fallback to standard sprite if artwork is missing
            image_url = artwork or sprites.get("front_default", "")

            pokemon_list.append(
                PokemonResponse(
                    id=data["id"],
                    name=data["name"].capitalize(),
                    height=data["height"],
                    weight=data["weight"],
                    types=types,
                    image_url=image_url
                )
            )
            
        return pokemon_list