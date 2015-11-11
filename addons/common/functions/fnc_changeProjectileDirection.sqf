/*
 * Author: commy2
 * Adjust a projectiles velocity and dir + up vector.
 *
 * Arguments:
 * 0: Projectile <OBJECT>
 * 1: Adjust azimuth this much. <NUMBER>
 * 2: Adjust inclination this much. <NUMBER>
 * 3: Adjust projectile speed this much. In m/s. (optional: 0) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_projectile", "_adjustDir", "_adjustUp", ["_adjustSpeed",0]];

private ["_vdir", "_dir", "_up", "_vlat", "_vup", "_vel"];

// get old direction vector
_vdir = vectorNormalized velocity _projectile;

// get azimuth and inclination and apply corrections
_dir = (_vdir select 0) atan2 (_vdir select 1) + _adjustDir;
_up = asin (_vdir select 2) + _adjustUp;

// get new direction vector (this is a unit vector)
_vdir = [
  sin _dir * cos _up,
  cos _dir * cos _up,
  sin _up
];

// get best up vector
_vlat = vectorNormalized (_vdir vectorCrossProduct [0,0,1]);
_vup = _vlat vectorCrossProduct _vdir;

// get new speed vector. Keep total speed, but change to new direction. Yay for vector commands.
_vel = _vdir vectorMultiply (_adjustSpeed + vectorMagnitude velocity _projectile);

// set projectile direction dir and up. Projectiles are long objects, especially with tracers, so it would look dumb otherwise.
_projectile setVectorDirAndUp [_vdir, _vup];

// set new speed vector
_projectile setVelocity _vel;