# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-bootc:44


RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf install -y dnf5-plugins && \
    dnf copr enable microwave/SCARECROW && \
    dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        scarecrow-adwaita-icon-theme \
        scarecrow-adwaita-cursor-theme \
        scarecrow-backgrounds \
        scarecrow-backgrounds-extras \
        scarecrow-bluetooth \
        scarecrow-control-center \
        scarecrow-desktop \
        scarecrow-gsettings-desktop-schemas \
        scarecrow-session \
        scarecrow-settings-daemon \
        scarecrow-shell \
        scdm \
        vater \
        xdg-desktop-portal-scarecrow \
        gnome-terminal \
        # temporary \
        nemo \
        xed && \
    dnf copr disable microwave/SCARECROW
    
RUN bootc container lint
