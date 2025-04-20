<?php

use App\Http\Controllers\ChatbotController;

Route::post('/ask', [ChatbotController::class, 'ask']);
