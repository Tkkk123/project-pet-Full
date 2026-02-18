export async function streamChatWithAI(
  message: string,
  onChunk: (text: string) => void,
  onDone: () => void,
  onError: (err: any) => void
) {
  try {
    const response = await fetch("http://localhost:8234/ai/chat", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ message })
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    if (!response.body) {
      throw new Error("Response body is null");
    }

    const reader = response.body.getReader();
    const decoder = new TextDecoder("utf-8");
    let buffer = "";

    while (true) {
      const { done, value } = await reader.read();
      if (done) {
        break;
      }

      const chunk = decoder.decode(value, { stream: true });
      buffer += chunk;

      const lines = buffer.split("\n\n");
      buffer = lines.pop() || "";

      for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed.startsWith("data: ")) continue;

        const dataStr = trimmed.slice(6).trim();
        if (dataStr === "[DONE]") {
          onDone();
          return;
        }

        try {
          const json = JSON.parse(dataStr);
          const content = json.choices?.[0]?.delta?.content || "";
          if (content) {
            onChunk(content);
          }
        } catch (e) {
          console.warn("解析 SSE JSON 失败:", e, dataStr);
        }
      }
    }

    if (buffer.trim().startsWith("data: ")) {
      const dataStr = buffer.trim().slice(6).trim();
      if (dataStr !== "[DONE]") {
        try {
          const json = JSON.parse(dataStr);
          const content = json.choices?.[0]?.delta?.content || "";
          if (content) onChunk(content);
        } catch (e) { }
      }
    }

    onDone();

  } catch (error) {
    console.error("Stream error:", error);
    onError(error);
  }
}
