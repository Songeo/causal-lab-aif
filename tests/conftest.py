"""Configuration for PyTest."""

from os import listdir, path

import pytest


def get_source(folder: str) -> str:
    """Returns the source path of the latest document in the specified folder.

    This function takes a folder path, retrieves the list of documents within that
    folder, and returns the absolute path of the latest document in the folder.

    Args:
        folder (str): The folder containing the documents.

    Returns:
        str: The absolute path of the latest document in the specified folder.

    """
    testdata_path = path.join("testdata", folder)
    documents = listdir(testdata_path)
    sources = [path.abspath(f"{testdata_path}/{document}") for document in documents]

    return sources[-1]


@pytest.fixture(scope="session")
def file_path(request: object) -> str:
    """Fixture that returns the file path based on the provided request parameter.

    This fixture is scoped to the session and returns the file path obtained using the
    `get_source` function based on the request parameter.

    Args:
        request (object): The request object containing the parameter to determine the
        file path.

    Returns:
        str: The file path obtained using the request parameter.

    """
    return get_source(request.param)
