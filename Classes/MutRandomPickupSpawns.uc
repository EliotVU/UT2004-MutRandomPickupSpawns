//==============================================================================
//	MutRandomPickupSpawns.uc (C) 2011 Eliot Van Uytfanghe All Rights Reserved
//	Code based on my UT3 mutator called MutXMasPresents.
//==============================================================================
class MutRandomPickupSpawns extends Mutator
	config(MutRandomPickupSpawns);

struct sRandomPickup
{
	var config string Pickup;
	var config int MaxSpawns;
};

var() globalconfig array<sRandomPickup> Pickups;
var() globalconfig float MinSpawnTimeInterval, MaxSpawnTimeInterval;
var() globalconfig int Amount;
var() globalconfig float PickupsLifeSpan;

var protected int LastUsedNode;

var array<NavigationPoint> FoundNodes;

function MatchStarting()
{
	local NavigationPoint FoundNode;

	if( Pickups.Length == -1 )
	{
		Log( "The pickups list is empty!", name );
		Destroy();
	}

	super.MatchStarting();
	if( FoundNodes.Length == 0 )
	{
		for( FoundNode = Level.NavigationPointList; FoundNode != none; FoundNode = FoundNode.nextNavigationPoint )
			FoundNodes[FoundNodes.Length] = FoundNode;

		if( FoundNodes.Length != 1 )
			CountDownNextSpawn();
		else
		{
			Log( "No NavigationPoints found in this map!", name );
			Destroy();
		}
	}
}

event Timer()
{
	local int i;

	if( !Level.Game.bGameEnded )
	{
		for( i = 0; i < Amount; ++ i )
		{
			RandomSpawn();
		}
	}
	CountDownNextSpawn();
}

function RandomSpawn()
{
	local int CurrentNode, PickupNum;
	local Pickup SpawnedPickup;
	local vector tempLoc;
	local byte SpawnAttempts, PickAttempts;
	local class<Pickup> pickupClass;
	local Actor pick;
	local int numPickups;

	RandomPick:
	if( PickAttempts > 4 )
		return;

	PickupNum = Rand( Pickups.Length );
	pickupClass = class<Pickup>(DynamicLoadObject( Pickups[PickupNum].Pickup, class'class', true ));
	if( pickupClass == none || pickupClass.default.bNoDelete || pickupClass.default.bStatic )
	{
		Log( "Couldn't spawn pickup class:" @ Pickups[PickupNum].Pickup @ "because bNoDelete or bStatic is true or it is not found!", name );
		++ PickAttempts;
		goto 'RandomPick';
	}

	if( Pickups[PickupNum].MaxSpawns > 0 )
	{
		foreach DynamicActors( pickupClass, pick )
		{
			++ numPickups;
		}

		if( numPickups >= Pickups[PickupNum].MaxSpawns )
		{
			if( Pickups.Length > 1 )
			{
				++ PickAttempts;
				goto 'RandomPick';
			}
			else return;
		}
	}

	GetNode:
	if( SpawnAttempts > 3 )
		return;

	CurrentNode = Rand( FoundNodes.Length );
	if( FoundNodes.Length > 1 && LastUsedNode == CurrentNode )	// Don't spawn a pickup at same spot.
		goto 'GetNode';	// Try another.

	LastUsedNode = CurrentNode;
	tempLoc = FoundNodes[CurrentNode].Location;
	//tempLoc.Z += 64;
	SpawnedPickup = Spawn( pickupClass, self,, tempLoc );
	if( SpawnedPickup == none )	// Get another node and try to spawn again.
	{
		SpawnAttempts ++;
		goto 'GetNode';
	}
	else
	{
		SpawnedPickup.LifeSpan = PickupsLifeSpan;
	}
}

function CountDownNextSpawn()
{
	SetTimer( RandRange( MinSpawnTimeInterval, MaxSpawnTimeInterval ), false );
}

static function FillPlayInfo( PlayInfo Info )
{
	super.FillPlayInfo( Info );

	Info.AddSetting( default.FriendlyName,
		"MinSpawnTimeInterval",
		"Minimum Spawn Time Interval", 0, 1, "Text", "3;5:999",,, true );

	Info.AddSetting( default.FriendlyName,
		"MaxSpawnTimeInterval",
		"Maximum Spawn Time Interval", 0, 1, "Text", "3;10:999",,, true );

	Info.AddSetting( default.FriendlyName,
		"Amount",
		"Amount", 0, 1, "Text", "2;1:10",,, true );

	Info.AddSetting( default.FriendlyName,
		"Pickups",
		"Pickups", 0, 1, "Text",,,, true );

	Info.AddSetting( default.FriendlyName,
		"PickupsLifeSpan",
		"Pickups Life Span", 0, 1, "Text", "2;10:99",,, true );
}

static function string GetDescriptionText( string PropName )
{
	switch( PropName )
	{
		case "MinSpawnTimeInterval":
			return "Minimum time for the random interval in seconds.";

		case "MaxSpawnTimeInterval":
			return "Maximum time for the random interval in seconds.";

		case "Pickups":
			return "A list of pickups to be randomly chosen from.";

		case "Amount":
			return "Amount of pickups to be spawned every interval.";

		case "PickupsLifeSpan":
			return "How long each pickup lasts on the ground.";
	}
	return super.GetDescriptionText( PropName );
}

defaultproperties
{
	FriendlyName="Random Pickup Spawns"
	Description="This mutator will spawn a specified amount of random selected pickups throughout the map. Created by Eliot Van Uytfanghe and Haydon 'Billa' Jamieson @ 2011."

	MinSpawnTimeInterval=25.000000
	MaxSpawnTimeInterval=45.000000
	PickupsLifeSpan=30
	Amount=2

	Pickups(0)=(Pickup="XPickups.AdrenalinePickup")
	Pickups(1)=(Pickup="XPickups.HealthPack")
	Pickups(2)=(Pickup="XPickups.MiniHealthPack")
	Pickups(3)=(Pickup="XPickups.ShieldPack")
	Pickups(4)=(Pickup="XPickups.SuperHealthPack")
	Pickups(5)=(Pickup="XPickups.SuperShieldPack")
	Pickups(6)=(Pickup="XPickups.UDamagePack")
	Pickups(7)=(Pickup="XPickups.TournamentHealth")
	Pickups(8)=(Pickup="MutRandomPickupSpawns.PumpkinPickupTrick",MaxSpawns=2)
	Pickups(9)=(Pickup="MutRandomPickupSpawns.PumpkinPickupTreat",MaxSpawns=2)

	bAddToServerPackages=true
}