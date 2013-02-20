//=============================================================================
// Pumpkin trick or treat!
//=============================================================================
class PumpkinPickupTrick extends PumpkinPickup;

event PostBeginPlay()
{
	super.PostBeginPlay();

	Level.Game.Broadcast( self, "ÿA TRICK pickup has been spawned!", 'CriticalEvent' );
}

function TrickOrTreat( Pawn other )
{
	if( other == none || other.Controller == none )
		return;

	other.Controller.Adrenaline = 0;
	other.DamageScaling = Max( other.DamageScaling - 0.5f, 0.5f );

	if( Rand( 3 ) == 2 )
	{
  		Spawn( class'PumpkinFreezer', other );
	}

	if( other.Weapon != none && Rand( 4 ) == 3 )
	{
		other.Weapon.DetachFromPawn( other );
		other.DeleteInventory( other.Weapon );
		other.Weapon.Destroy();

		if( other.Weapon == none )
		{
			other.NextWeapon();
		}
	}

	if( Rand( 5 ) == 4 )
	{
  		Spawn( class'PumpkinDegeneration', other );
	}
	else
	{
		other.TakeDamage( RandRange( 12, 31 ), none, other.Location, vect(0,0,0), class'Suicided' );
	}
}

defaultproperties
{
	PickupMessage="Ã¿TRICK! You have been tricked!"
}