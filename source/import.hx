import AssetPaths.AssetsImg;
import AssetPaths.AssetsData;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

import openfl.Assets;

import zero.flxutil.controllers.ZBaseController;
import zero.flxutil.controllers.ZPlayerController;
import zero.flxutil.particles.ZParticle;
import zero.flxutil.particles.ZParticleGroup;
import zero.flxutil.states.ZState;
import zero.flxutil.ui.ZBitmapText;

import zero.util.IntPoint;
import zero.util.Range;
import zero.util.Vector;

using Math;
using zero.ext.FloatExt;
using zero.ext.ArrayExt;
using zero.ext.StringExt;
using zero.ext.flx.FlxObjectExt;
using zero.ext.flx.FlxPointExt;
using zero.ext.flx.FlxSpriteExt;