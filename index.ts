import express, { Response } from "express"
import OpenAI from "openai"
import languages from "./list.json"
import { languages as language_type } from "./types"

const app = express()
let ai = new OpenAI({ apiKey: process.env.OPENAI_KEY })

app.use(express.json())

function createWritableStream(response: Response) {
    return new WritableStream({
        write(chunk: Uint8Array) {
            let processedChunk: OpenAI.Chat.Completions.ChatCompletionChunk = JSON.parse(Buffer.from(chunk).toString())
            response.write(processedChunk.choices[0].delta.content || "");
        },
        close() {
            response.end();
        },
        abort() {
            response.status(500).json({ error: "500 INTERNAL SERVER ERROR", message: "Our AI Model is having some issues, please be patient." })
        }
    });
}

async function getCompletion(prompt: string) {
    try {
        const response = await ai.chat.completions.create({
            model: "gpt-4o-mini",
            stream: true,
            stream_options: {
                include_usage: false
            },
            messages: [{ role: "user", content: prompt }]
        });
        return response.toReadableStream();
    } catch (error) {
        console.error("Error:", error);
    }
}

app.get("/programming-languages", (req, res) => {
    res.json(languages.map(e => {
        return {
            name: e.name
        }
    }))
    return
})

app.use((req, res, next) => {
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('Keep-Alive', 'timeout=120');
    next();
});

app.post("/query-language", async (req, res) => {
    let language: string = req.body.language
    let difficulty: number = parseInt(req.body.difficulty ?? "")
    let questions: number = parseInt(req.body.questions ?? "")
    if (!language || !difficulty || !questions) {
        res.status(400).json({ error: "400 BAD REQUEST", message: "Make sure you input an appropriate language, questions, and difficulty number" })
        return;
    }
    if (difficulty > 10 || difficulty < 0) {
        res.status(400).json({ error: "400 BAD REQUEST", message: "Difficulty number out of range" })
        return;
    }
    if (questions < 1 || questions > 50) {
        res.status(400).json({ error: "400 BAD REQUEST", message: "Questions number out of range" })
        return;
    }
    let exists = languages.find((e: language_type) => e.name.trim().toLowerCase() == language.toLowerCase())
    if (!exists) {
        res.status(404).json({ error: "404 NOT FOUND", message: "Could not find the given language" })
        return;
    }
    try {
        res.setHeader("Content-Type", "application/json")
        let comp = await getCompletion(`Provide exactly ${questions} MCQ, no more and no less, with 4 possible answers with difficulty of ${difficulty}/10 for the programming language ${language}. Provide only JSON with questions in the "questions" array, store the question number in the "number" field, store the answer as an index in the field "answer", store possible answers in the "options" field, store the question in the "question" field, and escape when needed. Please avoid formatting the code block and just send the raw code for these ${questions} questions.`);
        if (!comp) throw new Error()
        let stream = createWritableStream(res)
        comp.pipeTo(stream)
    } catch (_) {
        res.status(500).json({ error: "500 INTERNAL SERVER ERROR", message: "Our AI Model is having some issues, please be patient." })
        return;
    }
})

app.listen(process.env.PORT, () => {
    console.log(`App listening on port ${process.env.PORT}`)
})