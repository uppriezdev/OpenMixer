#!/bin/bash

# Qt specific paths
# QT_DIR="$HOME/Qt/6.8.0/gcc_64"
QT_DIR="/home/aika/Qt/6.8.0/gcc_64"
export PATH="$QT_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$QT_DIR/lib:$LD_LIBRARY_PATH"
export QML_IMPORT_PATH="$QT_DIR/qml"
export QML2_IMPORT_PATH="$QT_DIR/qml"

# Configuration variables
PROJECT_NAME="OpenMixer"
PROJECT_VERSION="1.0.0"
PROJECT_DIR="$(pwd)"
BUILD_DIR="${PROJECT_DIR}/build"
BIN_DIR="${PROJECT_DIR}/bin"
DEPLOY_DIR="${PROJECT_DIR}/deploy/${PROJECT_NAME}"
QT_VERSION="6.8.0"
LOG_FILE="${PROJECT_DIR}/build.log"

# Build options
BUILD_TYPE="release"
CLEAN_BUILD=false
VERBOSE=false
MAKE_JOBS=$(nproc)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to show help
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -d, --debug     Build in debug mode"
    echo "  -r, --release   Build in release mode (default)"
    echo "  -c, --clean     Clean build before building"
    echo "  -v, --verbose   Verbose output"
    echo "  -j N            Number of parallel make jobs (default: number of CPU cores)"
    echo "  -h, --help      Show this help message"
    exit 0
}

# Function to print colored messages
print_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${2}[${timestamp}] [${PROJECT_NAME}] ${1}${NC}" | tee -a "$LOG_FILE"
}

# Function to check if a command was successful
check_error() {
    if [ $? -ne 0 ]; then
        print_message "Error: $1" "$RED"
        print_message "Check ${LOG_FILE} for details" "$RED"
        exit 1
    fi
}

# Function to clean directories
clean_build() {
    print_message "Cleaning directories..." "$YELLOW"
    rm -rf "$BUILD_DIR"
    rm -rf "$BIN_DIR"
    rm -rf "${PROJECT_DIR}/deploy"
    mkdir -p "$BUILD_DIR"
    mkdir -p "$BIN_DIR"
    mkdir -p "$DEPLOY_DIR"
}

# Function to check dependencies
check_dependencies() {
    print_message "Checking dependencies..." "$YELLOW"

    # Check Qt installation
    if [ ! -d "$QT_DIR" ]; then
        print_message "Qt directory not found at: $QT_DIR" "$RED"
        exit 1
    fi

    # Check qmake
    if ! command -v qmake &> /dev/null; then
        print_message "qmake not found in PATH. Check Qt installation." "$RED"
        exit 1
    fi

    # Check make
    if ! command -v make &> /dev/null; then
        print_message "make not found. Please install build tools." "$RED"
        exit 1
    fi

    print_message "Using Qt from: $QT_DIR" "$BLUE"
    print_message "qmake path: $(which qmake)" "$BLUE"
}

# Function to build the application
build_app() {
    print_message "Building $PROJECT_NAME version $PROJECT_VERSION ($BUILD_TYPE)..." "$YELLOW"

    cd "$BUILD_DIR" || exit 1

    # Configure build type and options
    BUILD_OPTIONS=""
    if [ "$BUILD_TYPE" = "debug" ]; then
        BUILD_OPTIONS="CONFIG+=debug CONFIG-=release"
    else
        BUILD_OPTIONS="CONFIG+=release CONFIG-=debug CONFIG+=strip"
    fi

    if [ "$VERBOSE" = true ]; then
        BUILD_OPTIONS="$BUILD_OPTIONS CONFIG+=verbose"
    fi

    # Run qmake
    print_message "Running qmake..." "$BLUE"
    "$QT_DIR/bin/qmake" "$PROJECT_DIR/openmixer.pro" $BUILD_OPTIONS 2>&1 | tee -a "$LOG_FILE"
    check_error "Failed to run qmake"

    # Run make
    print_message "Running make with $MAKE_JOBS jobs..." "$BLUE"
    make -j"$MAKE_JOBS" 2>&1 | tee -a "$LOG_FILE"
    check_error "Failed to build application"

    print_message "Build completed successfully!" "$GREEN"
}

create_portable() {
    print_message "Creating portable package..." "$YELLOW"

    # Create directory structure with proper plugin directories
    mkdir -p "$DEPLOY_DIR/bin"
    mkdir -p "$DEPLOY_DIR/lib"
    mkdir -p "$DEPLOY_DIR/plugins/platforms"
    mkdir -p "$DEPLOY_DIR/plugins/imageformats"
    mkdir -p "$DEPLOY_DIR/plugins/iconengines"
    mkdir -p "$DEPLOY_DIR/resources"
    mkdir -p "$DEPLOY_DIR/qml"

    # Copy executable
    cp "$BIN_DIR/$PROJECT_NAME" "$DEPLOY_DIR/bin/" 2>/dev/null || {
        print_message "Warning: No executable found in bin directory" "$YELLOW"
        # Try to find the executable in the build directory
        find "$BUILD_DIR" -name "$PROJECT_NAME" -type f -executable -exec cp {} "$DEPLOY_DIR/bin/" \;
    }
    check_error "Failed to copy executable"

    # Copy resources
    if [ -d "$PROJECT_DIR/Resources" ]; then
        cp -r "$PROJECT_DIR/Resources"/* "$DEPLOY_DIR/resources/"
        check_error "Failed to copy resources"
    fi

    # Copy Qt dependencies
    print_message "Copying Qt dependencies..." "$BLUE"

    # Copy required Qt libraries
    if [ -f "$DEPLOY_DIR/bin/$PROJECT_NAME" ]; then
        for lib in $(ldd "$DEPLOY_DIR/bin/$PROJECT_NAME" | grep "$QT_DIR" | awk '{print $3}'); do
            if [ -f "$lib" ]; then
                cp "$lib" "$DEPLOY_DIR/lib/"
                check_error "Failed to copy Qt library: $lib"
            fi
        done
    else
        print_message "Warning: Executable not found for dependency copying" "$YELLOW"
    fi

    # Copy Qt plugins with error checking
    print_message "Copying Qt plugins..." "$BLUE"

    # Platforms
    if [ -d "$QT_DIR/plugins/platforms" ]; then
        cp "$QT_DIR/plugins/platforms/"*.so "$DEPLOY_DIR/plugins/platforms/" 2>/dev/null ||
            print_message "Warning: No platform plugins found" "$YELLOW"
    fi

    # Image formats
    if [ -d "$QT_DIR/plugins/imageformats" ]; then
        cp "$QT_DIR/plugins/imageformats/"*.so "$DEPLOY_DIR/plugins/imageformats/" 2>/dev/null ||
            print_message "Warning: No imageformat plugins found" "$YELLOW"
    fi

    # Icon engines
    if [ -d "$QT_DIR/plugins/iconengines" ]; then
        cp "$QT_DIR/plugins/iconengines/"*.so "$DEPLOY_DIR/plugins/iconengines/" 2>/dev/null ||
            print_message "Warning: No iconengine plugins found" "$YELLOW"
    fi

    # Copy QML modules if used
    if [ -d "$QT_DIR/qml" ]; then
        cp -r "$QT_DIR/qml" "$DEPLOY_DIR/"
    fi

    # Create run script
    cat > "$DEPLOY_DIR/run_${PROJECT_NAME}.sh" << EOF
#!/bin/bash
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
export LD_LIBRARY_PATH="\$SCRIPT_DIR/lib:\$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="\$SCRIPT_DIR/plugins"
export QML2_IMPORT_PATH="\$SCRIPT_DIR/qml"
export QT_QPA_PLATFORM_PLUGIN_PATH="\$SCRIPT_DIR/plugins/platforms"
"\$SCRIPT_DIR/bin/$PROJECT_NAME" "\$@"
EOF

    chmod +x "$DEPLOY_DIR/run_${PROJECT_NAME}.sh"

    # Create README
    cat > "$DEPLOY_DIR/README.txt" << EOF
$PROJECT_NAME v$PROJECT_VERSION
Portable Version

To run the application:
1. Make sure the run script is executable (chmod +x run_${PROJECT_NAME}.sh)
2. Run ./run_${PROJECT_NAME}.sh

Note: This is a portable version. Keep all files together in the same directory structure.
EOF

    # Create version file
    echo "$PROJECT_VERSION" > "$DEPLOY_DIR/version.txt"

    # Create archive
    print_message "Creating archive..." "$BLUE"
    cd "${PROJECT_DIR}/deploy" || exit 1
    tar -czf "${PROJECT_NAME}_v${PROJECT_VERSION}_portable.tar.gz" "${PROJECT_NAME}"
    check_error "Failed to create portable archive"

    print_message "Portable package created successfully!" "$GREEN"
    print_message "Location: ${PROJECT_DIR}/deploy/${PROJECT_NAME}_v${PROJECT_VERSION}_portable.tar.gz" "$BLUE"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--debug)
            BUILD_TYPE="debug"
            shift
            ;;
        -r|--release)
            BUILD_TYPE="release"
            shift
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -j)
            shift
            if [[ $1 =~ ^[0-9]+$ ]]; then
                MAKE_JOBS=$1
            else
                print_message "Invalid number of jobs" "$RED"
                exit 1
            fi
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            print_message "Unknown option: $1" "$RED"
            show_help
            ;;
    esac
done

# Main execution
main() {
    # Create/clear log file
    echo "Build Log - $(date)" > "$LOG_FILE"

    print_message "Starting build process for $PROJECT_NAME v$PROJECT_VERSION" "$YELLOW"
    print_message "Build type: $BUILD_TYPE" "$BLUE"
    print_message "Build jobs: $MAKE_JOBS" "$BLUE"

    # Check dependencies
    check_dependencies

    # Clean if requested
    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi

    # Create build directory if it doesn't exist
    mkdir -p "$BUILD_DIR"

    # Build application
    build_app

    # Create portable package
    create_portable

    print_message "Build process completed successfully!" "$GREEN"
    print_message "Log file: $LOG_FILE" "$BLUE"
}

# Execute main function
main
