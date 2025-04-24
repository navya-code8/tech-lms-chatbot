<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ChatbotController;

Route::post('/ask', [ChatbotController::class, 'ask']);

Route::get('/test', function () {
    return response()->json(['message' => 'API is working']);
});

Route::get('/', function () {
    return redirect('/chatbotTest.html');
});

Route::get('/test-openai', function () {
    $openaiKey = env('OPENAI_API_KEY');
    $faqs = json_decode(file_get_contents(storage_path('app/faqs.json')), true);

    return response()->json([
        'openai_key' => $openaiKey ? 'Valid' : 'Not Set',
        'faqs' => $faqs
    ]);
});

