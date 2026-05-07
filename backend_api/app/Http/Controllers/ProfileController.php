<?php
namespace App\Http\Controllers;

use App\Models\Profile;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function index() { // index() → ambil semua data dari database, kirim sebagai JSON
        return response()->json(Profile::all());
    }

    public function store(Request $request) { // store() → validasi input lalu simpan data baru ke database
        $data = $request->validate([
            'nrp'           => 'required|string',
            'program_studi' => 'required|string',
            'email'         => 'required|string',
            'phone'         => 'required|string',
            'location'      => 'required|string',
        ]);
        $profile = Profile::create($data);
        return response()->json(['data' => $profile], 201);
    }

   // update validasi input lalu update data yang sudah ada
    public function update(Request $request, Profile $profile) {
        $data = $request->validate([
            'nrp'           => 'required|string',
            'program_studi' => 'required|string',
            'email'         => 'required|string',
            'phone'         => 'required|string',
            'location'      => 'required|string',
        ]);
        $profile->update($data);
        return response()->json(['data' => $profile]);
    }

    // destroy -> hapus data dari database
    public function destroy(Profile $profile) {
        $profile->delete();
        return response()->json(['message' => 'Deleted']);
    }
}