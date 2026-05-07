<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProfileController;

// baris ini otomatis membuat 4 endpoint sekaligus
//GET (Ambil semua data profil), POST(Tambah data profil baru), PUT(Update data profil), DELETE(Hapus data profil)
Route::apiResource('profiles', ProfileController::class);