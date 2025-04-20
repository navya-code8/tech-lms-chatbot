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

        //load FAQs from JSON
        $faqData = json_decode(file_get_contents(storage_path('app/faqs.json')), true);

        //build the OpenAI prompt
        $prompt = "User asked: \"$userQuestion\". Choose the most relevant FAQ from below and respond ONLY with the FAQ answer:\n\n";
        foreach ($faqData as $faq) {
            $prompt .= "Q: " . $faq['question'] . "\nA: " . $faq['answer'] . "\n\n";
        }

        //create the OpenAI client
        $client = OpenAI::factory()
            ->withApiKey(env('OPENAI_API_KEY'))
            ->withHttpClient(new Client([
                'verify' => env('OPENAI_CACERT'), 
            ]))
            ->make();

        //get a response from OpenAI
        $response = $client->chat()->create([
            'model' => 'gpt-3.5-turbo',
            'messages' => [
                ['role' => 'system', 'content' => 'You are a helpful FAQ assistant for a Tech LMS.'],
                ['role' => 'user', 'content' => $prompt],
            ],
        ]);

        $botAnswer = $response->choices[0]->message->content;

        return response()->json([
            'question' => $userQuestion,
            'answer' => $botAnswer
        ]);
    }
}
