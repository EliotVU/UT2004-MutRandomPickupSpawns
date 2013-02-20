class PumpkinRegeneration extends Info;

event PostBeginPlay()
{
	if( Pawn(Owner) == none )
	{
		Destroy();
		return;
	}

	SetTimer( 0.1, true );
}

event Timer()
{
	if( Pawn(Owner) == none )
	{
		Destroy();
		return;
	}

	Pawn(Owner).GiveHealth( 1, Pawn(Owner).SuperHealthMax );
	if( Pawn(Owner).Health >= Pawn(Owner).SuperHealthMax )
		Pawn(Owner).AddShieldStrength( 1 );
}


defaultproperties
{
	LifeSpan=10
}
