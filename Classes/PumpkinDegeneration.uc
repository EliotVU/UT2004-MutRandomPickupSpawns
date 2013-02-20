class PumpkinDegeneration extends Info;

event PostBeginPlay()
{
	if( Pawn(Owner) == none )
	{
		Destroy();
		return;
	}

	SetTimer( 0.4, true );
}

event Timer()
{
	if( Pawn(Owner) == none )
	{
		Destroy();
		return;
	}

	Pawn(Owner).TakeDamage( RandRange( 2, 4 ), none, owner.Location, vect(0,0,0), class'Suicided' );
}


defaultproperties
{
	LifeSpan=10
}
