<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Chatbot</title>
</head>

<body>
    <h2>Tech LMS Chatbot</h2>
    <input type="text" id="question" placeholder="Ask a question..." />
    <button onclick="ask()">Ask</button>
    <p id="response"></p>

    <script>
        async function ask() {
            const question = document.getElementById('question').value;
            const responseEl = document.getElementById('response');

            try {
                const response = await fetch('/api/ask', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                    },
                    body: JSON.stringify({ question })
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    responseEl.innerText = "Error: " + (errorData.error || "Unknown error");
                    return;
                }

                const data = await response.json();
                responseEl.innerText = data.answer || "No answer provided.";
            } catch (err) {
                responseEl.innerText = "An error occurred: " + err.message;
            }
        }

    </script>
</body>

</html>