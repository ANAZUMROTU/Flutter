<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Profile extends Model {
    protected $fillable = [ // mendefinisikan kolom mana yang boleh diisi: nrp, program_studi, email, phone, location.
        'nrp', 'program_studi', 'email', 'phone', 'location'
    ];
}