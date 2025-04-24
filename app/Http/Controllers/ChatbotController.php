<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use OpenAI;
use GuzzleHttp\Client;

class ChatbotController extends Controller
{
    public function ask(Request $request)
    {
        $userQuestion = $request->input('question');

        if (!$userQuestion) {
            return response()->json(['error' => 'Question is required'], 400);
        }

        try {
            $faqData = json_decode(file_get_contents(storage_path('app/faqs.json')), true);

            $prompt = "User asked: \"$userQuestion\". Choose the most relevant FAQ from below and respond ONLY with the FAQ answer:\n\n";
            foreach ($faqData as $faq) {
                $prompt .= "Q: " . $faq['question'] . "\nA: " . $faq['answer'] . "\n\n";
            }

            $client = OpenAI::factory()
                ->withApiKey(env('OPENAI_API_KEY'))
                ->withHttpClient(new Client([
                    'verify' => false
                ]))
                ->make();

            $response = $client->chat()->create([
                'model' => 'gpt-3.5-turbo',
                'messages' => [
                    ['role' => 'system', 'content' => 'You are a helpful FAQ assistant for a Tech LMS.'],
                    ['role' => 'user', 'content' => $prompt],
                ],
            ]);

            $botAnswer = $response->choices[0]->message->content ?? 'No response from AI.';

            return response()->json([
                'question' => $userQuestion,
                'answer' => $botAnswer
            ]);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Server error: ' . $e->getMessage()], 500);
        }
    }

}
