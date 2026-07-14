from pydantic import BaseModel
from typing import List

class PokemonResponse(BaseModel):
    id: int
    name: str
    height: int
    weight: int
    types: List[str]
    image_url: str

    