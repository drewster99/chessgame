#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🚀 Building ChessGame..."

# Clean previous build
echo "Cleaning..."
swift package clean

# Build the package
echo "Building..."
if swift build; then
    echo -e "${GREEN}✅ Build successful!${NC}"
    echo "🎮 Running ChessGame..."
    swift run ChessGame
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo "🎉 Build process completed!" 