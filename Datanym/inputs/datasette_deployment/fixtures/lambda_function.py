import asyncio
from datasette.app import Datasette
import mangum


ds = Datasette(["fixtures.db"])
# Handler wraps the Datasette ASGI app with Mangum:
lambda_handler = mangum.Mangum(ds.app())