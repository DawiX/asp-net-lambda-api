#!/bin/bash
NAME=$(pwd | sed 's/.*\///')
dotnet restore src/asp-lambda
# dotnet restore Lambda.Tests

# dotnet test Lambda.Tests
dotnet lambda package --project-location src/asp-lambda --output-package "$NAME".zip
