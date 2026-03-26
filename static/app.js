// Amni-Code Frontend JavaScript

document.addEventListener('DOMContentLoaded', () => {
    const promptInput = document.getElementById('prompt-input');
    const sendBtn = document.getElementById('send-btn');
    const messages = document.getElementById('messages');
    const modelSelect = document.getElementById('model-select');
    const codeEditor = document.getElementById('code-editor');
    const terminalInput = document.getElementById('terminal-input');
    const terminalOutput = document.getElementById('terminal-output');
    const tabs = document.querySelectorAll('.tab');

    // Tab switching
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
            tab.classList.add('active');
            document.getElementById(tab.dataset.tab + '-tab').classList.add('active');
        });
    });

    // Send message
    async function sendMessage() {
        const prompt = promptInput.value.trim();
        if (!prompt) return;

        addMessage(prompt, 'user');
        promptInput.value = '';

        try {
            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    prompt,
                    model_name: modelSelect.value
                })
            });

            if (response.ok) {
                const data = await response.json();
                addMessage(data.response, 'assistant');
            } else {
                addMessage('Error: Failed to get response', 'assistant');
            }
        } catch (error) {
            addMessage('Error: ' + error.message, 'assistant');
        }
    }

    function addMessage(text, type) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${type}`;
        messageDiv.textContent = text;
        messages.appendChild(messageDiv);
        messages.scrollTop = messages.scrollHeight;
    }

    sendBtn.addEventListener('click', sendMessage);
    promptInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });

    // Terminal simulation
    terminalInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            const command = terminalInput.value;
            terminalOutput.textContent += `> ${command}\n`;
            // Simulate command execution
            setTimeout(() => {
                terminalOutput.textContent += `Executed: ${command}\n`;
                terminalInput.value = '';
            }, 500);
        }
    });

    // File tree simulation
    const fileTree = document.getElementById('file-tree');
    fileTree.innerHTML = `
        <div>📁 src/</div>
        <div>&nbsp;&nbsp;📄 main.rs</div>
        <div>&nbsp;&nbsp;📄 lib.rs</div>
        <div>📁 static/</div>
        <div>&nbsp;&nbsp;📄 index.html</div>
        <div>&nbsp;&nbsp;📄 style.css</div>
        <div>&nbsp;&nbsp;📄 app.js</div>
        <div>📄 Cargo.toml</div>
    `;

    // New chat
    document.getElementById('new-chat-btn').addEventListener('click', () => {
        messages.innerHTML = '';
        codeEditor.value = '';
        terminalOutput.textContent = '';
    });
});