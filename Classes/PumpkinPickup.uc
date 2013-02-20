class PumpkinPickup extends TournamentPickUp;

#exec obj load file="Content/BillaHalloweenMPack.usx" package="MutRandomPickupSpawns"
#exec obj load file="Content/BillaHalloweenTex.utx" package="MutRandomPickupSpawns"

auto state Pickup
{
	// When touched by an actor.
	function Touch( Actor other )
	{
		// if touched by a player pawn, let him pick this up.
		if( ValidTouch( Other ) )
		{
			TrickOrTreat( Pawn(other) );
			AnnouncePickup( Pawn(Other) );
			Destroy();
		}
	}
}

function TrickOrTreat( Pawn other );

static function StaticPrecache( LevelInfo L )
{
	L.AddPrecacheMaterial( Material'CellShader' );
	L.AddPrecacheStaticMesh( StaticMesh'BillaPumpkin' );
}

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial( Material'CellShader' );

	super.UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheStaticMeshes()
{
	Level.AddPrecacheStaticMesh( StaticMesh'BillaPumpkin' );
	Super.UpdatePrecacheStaticMeshes();
}

defaultproperties
{
	RespawnTime=45.000000
	MaxDesireability=0.300000
	AmbientGlow=128
	CollisionRadius=18.000000
	CollisionHeight=10.000000
	Drawscale=0.15
	Mass=10.000000
	Physics=PHYS_Rotating
	RotationRate=(Yaw=24000)
	PickupSound=sound'PickupSounds.AdrenelinPickup'
	PickupForce="AdrenelinPickup"
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'BillaPumpkin'
	Skins(0)=Shader'CellShader'
	Skins(1)=Shader'CellShader'
	ScaleGlow=0.6
	LightType=LT_Steady
	LightHue=21
	LightBrightness=255.000000
	LightRadius=2.0
	bDynamicLight=True
	bNoDelete=False
	bStatic=False
}
