//=============================================================================
// Pumpkin trick or treat!
//=============================================================================
class PumpkinPickupTreat extends PumpkinPickup;

event PostBeginPlay()
{
	super.PostBeginPlay();

	Level.Game.Broadcast( self, "ÿ€A TREAT pickup has been spawned!", 'CriticalEvent' );
}

function TrickOrTreat( Pawn other )
{
	if( other == none || other.Controller == none )
		return;

	if( other.Controller.Adrenaline < other.Controller.AdrenalineMax )
	{
		other.Controller.Adrenaline = Min( other.Controller.Adrenaline + 100, other.Controller.AdrenalineMax );
	}

	if( Rand( 3 ) == 2 )
	{
		other.EnableUDamage( RandRange( 15, 30 ) );
	}

	if( xPawn(other) != none && Rand( 4 ) == 3 )
	{
		xPawn(other).bBerserk = true;
	}

	if( Rand( 7 ) == 6 )
	{
		other.GroundSpeed *= 1.5f;
		other.AirSpeed *= 1.5f;
		other.WaterSpeed *= 1.5f;
	}

	if( Rand( 2 ) == 1 )
	{
  		Spawn( class'PumpkinRegeneration', other );
	}
}

defaultproperties
{
	PickupMessage="Ã¿â‚¬TREAT! You have been granted a treat!"
}