# Logging helper recipes
log level message:
  @case {{level}} in \
    "info")    echo -e "\e[1;34m{{message}}\e[0m" ;; \
    "step")    echo -e "\e[1;33m>> {{message}}\e[0m" ;; \
    "success") echo -e "\e[1;32m{{message}}\e[0m" ;; \
    "error")   echo -e "\e[1;31m{{message}}\e[0m" ;; \
    "result")  echo -e "\e[1;36m{{message}}\e[0m" ;; \
    *)         echo -e "{{message}}" ;; \
  esac

build distro:
  @just log info "===== Starting build for {{distro}} WSL distro ====="

  @just log step "Building Docker image..."
  @cd distro/{{distro}} && docker build -t {{distro}}-wsl .

  @just log step "Creating output directory..."
  @mkdir -p bin/{{distro}}

  @just log step "Running container to prepare filesystem..."
  @docker run -t --name {{distro}}-wsl {{distro}}-wsl

  @just log step "Exporting container to tarball..."
  @docker export {{distro}}-wsl | tar --delete --wildcards "etc/resolv.conf" > bin/{{distro}}/{{distro}}-wsl.tar

  @just log step "Cleaning up container..."
  @docker rm {{distro}}-wsl

  @just log step "Finalizing WSL image..."
  @mv bin/{{distro}}/{{distro}}-wsl.tar bin/{{distro}}/{{distro}}.wsl

  @just log success "===== {{distro}} WSL distro build completed successfully ====="
  @just log result "Output file: bin/{{distro}}/{{distro}}.wsl"



