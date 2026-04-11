const fs = require('fs');
let text = fs.readFileSync('index.html', 'utf8');

text = text.replace(
  /<h3 id="editor-filename">[^<]+<\/h3>\s*<div>\s*<button[^>]+>💾<\/button>\s*<button[^>]+>✕<\/button>\s*<\/div>/,
  `<h3 id="editor-filename">untitled.py</h3>
        <div>
          <button class="icon-btn" onclick="requestAISuggestion()" title="AI Suggestion (Ctrl+Space)">✨</button>
          <button class="icon-btn" onclick="saveEditorFile()" title="Save to Workspace (Ctrl+S)">💾</button>
          <button class="icon-btn" onclick="toggleEditor()" title="Close">✕</button>
        </div>`
);

let initIdx = text.indexOf("scrollBeyondLastLine: false");
if (initIdx !== -1) {
  text = text.replace(
    /scrollBeyondLastLine: false\s*}\);\s*console\.log\('Monaco editor initialized/,
    `scrollBeyondLastLine: false
    });
    monacoEditor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS, () => saveEditorFile());
    monacoEditor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.Space, () => requestAISuggestion());
    console.log('Monaco editor initialized`
  );
}

text = text.replace(
  /}\s*\$\('#editor-toggle'\)/,
  `}

function requestAISuggestion() {
  if (!monacoEditor || !currentEditorFile) return;
  const content = monacoEditor.getValue();
  const cursor = monacoEditor.getPosition();
  const prompt = \`AI suggestion/completion for \${currentEditorFile} around line \${cursor.lineNumber}:\n\`\`\`\n\${content}\n\`\`\`\n\`;
  $('#input').value = prompt;
  $('#send').click();
  toggleEditor(); // Maybe hide editor so they can see chat, or stay open? Let's leave open
}

$('#editor-toggle')`
);

fs.writeFileSync('index.html', text, 'utf8');
console.log('Patch complete.');
