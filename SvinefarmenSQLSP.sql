create or replace procedure SP_InsertFK_StallMonitor(
   FKStall_No int,
   FKSmartUnit_SerialNumber varchar(6)
)
language plpgsql    
as $$
begin
    
	SELECT @FKStall_No = PKStall_No FROM Stall;
	SELECT @FKSmartUnit_SerialNumber = PKSmartUnit_SerialNumber FROM SmartUnit;
	
	INSERT INTO StallMonitor(FKStall_No, FKSmartUnit_SerialNumber)
    VALUES(@FKStall_No, @FKSmartUnit_SerialNumber);

    commit;
end;$$;