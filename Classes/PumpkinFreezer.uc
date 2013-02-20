class PumpkinFreezer extends Info;

var int GroundSpeedCut;

event PostBeginPlay()
{
	local int orgSpeed;

	if( xPawn(Owner) == none )
	{
		Destroy();
		return;
	}

	orgSpeed = xPawn(Owner).GroundSpeed;
	xPawn(Owner).GroundSpeed *= 0.2;
	GroundSpeedCut = orgSpeed - xPawn(Owner).GroundSpeed;
	SetTimer( 20, false );
}

event Timer()
{
	if( xPawn(Owner) == none )
	{
		Destroy();
		return;
	}

	xPawn(Owner).GroundSpeed += GroundSpeedCut;
	Destroy();
}


defaultproperties
{
}
