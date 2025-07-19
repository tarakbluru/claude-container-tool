FROM node:lts
RUN npm install -g @anthropic-ai/claude-code

# Set up git configuration script
RUN echo '#!/bin/bash\nif [ -n "$GIT_USER_NAME" ]; then git config --global user.name "$GIT_USER_NAME"; fi\nif [ -n "$GIT_USER_EMAIL" ]; then git config --global user.email "$GIT_USER_EMAIL"; fi\nexec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]