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
