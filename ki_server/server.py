import os
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)


def call_openwebui(prompt: str) -> str:
    url = os.environ.get("OPENWEBUI_URL")
    if not url:
        raise RuntimeError("OPENWEBUI_URL not set")
    token = os.environ.get("OPENWEBUI_TOKEN")
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    payload = {"prompt": prompt}
    resp = requests.post(url, json=payload, headers=headers, timeout=60)
    resp.raise_for_status()
    data = resp.json()
    return data.get("reply") or str(data)


def call_grok(prompt: str) -> str:
    url = os.environ.get("GROK_URL")
    if not url:
        raise RuntimeError("GROK_URL not set")
    token = os.environ.get("GROK_TOKEN")
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    payload = {"prompt": prompt}
    resp = requests.post(url, json=payload, headers=headers, timeout=60)
    resp.raise_for_status()
    data = resp.json()
    return data.get("reply") or str(data)


def call_chatgpt(prompt: str) -> str:
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        raise RuntimeError("OPENAI_API_KEY not set")
    model = os.environ.get("OPENAI_MODEL", "gpt-3.5-turbo")
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
    }
    resp = requests.post(
        "https://api.openai.com/v1/chat/completions",
        headers=headers,
        json=payload,
        timeout=60,
    )
    resp.raise_for_status()
    data = resp.json()
    return data["choices"][0]["message"]["content"]


PROVIDERS = {
    "openwebui": call_openwebui,
    "grok": call_grok,
    "chatgpt": call_chatgpt,
}


@app.route("/chat", methods=["POST"])
def chat():
    body = request.get_json()
    if not body or "message" not in body:
        return jsonify({"error": "missing 'message' field"}), 400

    prompt = body["message"]
    provider = os.environ.get("KI_PROVIDER", "chatgpt").lower()
    func = PROVIDERS.get(provider)
    if not func:
        return jsonify({"error": f"unknown provider {provider}"}), 400

    try:
        reply = func(prompt)
    except Exception as exc:
        return jsonify({"error": str(exc)}), 500

    return jsonify({"reply": reply})


if __name__ == "__main__":
    host = os.environ.get("HOST", "0.0.0.0")
    port = int(os.environ.get("PORT", "8080"))
    app.run(host=host, port=port)
