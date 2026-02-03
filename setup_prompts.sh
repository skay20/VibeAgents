#!/bin/bash

# Nombre del archivo maestro
PROMPT_FILE="PROMPT_MASTER.xml"

# Verificar si existe el prompt maestro
if [ ! -f "$PROMPT_FILE" ]; then
  echo "❌ No se encuentra $PROMPT_FILE en el directorio actual."
  exit 1
fi

echo "✅ Usando prompt fuente: $PROMPT_FILE"

# Crear directorios requeridos por cada herramienta
mkdir -p \
  .gemini/prompts \
  .windsurf/project-prompts \
  .windsurf/context \
  .claude/artifacts \
  .vscode/prompts \
  chatgpt_project/context-files

# Copiar el prompt a cada destino
cp "$PROMPT_FILE" .gemini/prompts/frontend-copilot.xml
cp "$PROMPT_FILE" .windsurf/project-prompts/frontend-copilot.xml
cp "$PROMPT_FILE" .claude/project-prompt.xml
cp "$PROMPT_FILE" .vscode/prompts/frontend-copilot.xml
cp "$PROMPT_FILE" chatgpt_project/instructions.xml

# Configuración de Windsurf
cat > .windsurf/assistant-config.json <<EOF
{
  "activePrompt": "frontend-copilot.xml"
}
EOF

# Crear contextos básicos para cada herramienta
echo -e "# Gemini Context\nThis is a Gemini CLI context for the current project." > .gemini/context.md
echo -e "# Windsurf Context\nReact + Tailwind + Firebase app with real-time sync." > .windsurf/context/project-context.md
echo -e "# Claude Context\nClaude is helping with a frontend project using Firebase." > .claude/context.md

# ChatGPT context files
echo -e "# Tech Stack\n- React\n- TailwindCSS\n- Firebase" > chatgpt_project/context-files/tech-stack.md
echo -e "# Project Structure\n- src/components\n- services/\n- hooks/\n- styles/" > chatgpt_project/context-files/project-structure.md
echo -e "# Requirements\n- Login with Firebase\n- Notes CRUD\n- Real-time updates" > chatgpt_project/context-files/requirements.md

# Configuración de VSCode para Copilot
cat > .vscode/settings.json <<EOF
{
  "copilot.prompts": {
    "frontend-assistant": "./vscode/prompts/frontend-copilot.xml"
  }
}
EOF

echo "🎉 ¡Todos los archivos fueron configurados correctamente!"


