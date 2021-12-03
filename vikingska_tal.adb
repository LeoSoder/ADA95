--Läser in strängar från textfil och ger värde från a-->g samt placerar sorterad sträng och värde i separat textfil. Huvudprogram skriver ut största värdet
--och sorterad sträng.

with Ada.Command_Line;                       Use Ada.Command_Line;
with Ada.Text_IO;                            Use Ada.Text_IO;
with Ada.Integer_Text_IO;                    Use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;                  Use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;          Use Ada.Strings.Unbounded.Text_IO;


procedure Vikingska_Tal is

   subtype rangec is Character range 'a'..'g';
   type Value_Array is array (rangec) of positive; --Array för värdet på bokstäver
   -------------------------------------------------------------------------
   --Sparar störta värdet och sorterad sträng
   -------------------------------------------------------------------------
   procedure Max_Vikingsk(Value : in Integer; String2 : in String; Max_Value : in out Integer; Max_String : out String) is

   Begin
      if Value > Max_Value then
	      Max_Value := Value;
	      Max_String := String2;
      end if;

   End Max_Vikingsk;
   -------------------------------------------------------------------------
   --Sorterar bokstäver
   -------------------------------------------------------------------------
   procedure New_Vikingsk (String1 : in String; String2 : Out String; Value : in Integer; Check_Value : in Value_Array) is

      Value_Temp : Integer;
      
   Begin

      Value_Temp := Value;
      String2 := (Others => ' ');
      
   for J in 1..31 loop --Placerar bokstav med störst värde och subtraherar summan
	   for I in reverse Check_Value'range loop 
         if Value_Temp - Check_Value(I) >= 1 or Value_Temp - Check_Value(I) = 0 then
            String2(J) := I;
            Value_Temp := Value_Temp - Check_Value(I);
               exit;
         end if;
      end loop;
   end loop;
      
   End New_Vikingsk;
   -------------------------------------------------------------------
   --Hämtar värde för bokstäverna
   -------------------------------------------------------------------
   function Get_Value(String_Line : in String; Check_Value : in Value_Array) return Integer is

   Value : Integer := 0;
   Begin

   for I in Check_Value'range loop
	   for J in 1..20 loop
	      if (String_Line(J) not in 'a'..'g') and (String_Line(J) /= ' ') then
	       return 0;  --Om bokstav är utanför a-->g
	      end if;

	      if String_Line(J) = I then
	       Value := Value + Check_Value(I);
	      end if;

	   end loop;
   end loop;

      return Value;
   End Get_Value;
   ------------------------------------------------
   --Överför data till sorteringsfil
   ------------------------------------------------
   procedure Copy(Source, Dest : in File_Type; Max_Value : in out Integer; Max_String : out String) is
      String1 : String(1..21);
      String2 : String(1..31);
      Value, Last : Integer := 0;
      Check_Value : constant Value_Array := (1, 7, 12, 42, 112, 365, 1024);
      
   Begin

   while not End_Of_File(Source) loop
	   while not End_Of_Line(Source) loop
	      String1 := (Others => ' ');

	      Get_Line(Source, String1,Last);


	      Value := Get_Value(String1, Check_Value);

	      if Value > 0 then
	         Put(Dest, "|");
	         Put(Dest, String1(1..20));
	         Put(Dest, "|");
	       
	         New_Vikingsk(String1, String2, Value, Check_Value);  ----Sorterar bokstäver
	         Max_Vikingsk(Value, String2, Max_Value, Max_String); ----Sparar största värdet

	            If String1 /= String2(1..21) then  ----kontrollerar om sorterad /= ej sorterad
		            Put(Dest, String2(1..31));
	            else
		            String2 := (Others => ' ');  ----"rensar" om sorterad = ej sorterad
		            Put(Dest, String2(1..31));
	            end if;
	         Put(Dest, "|");
	         Put(Dest, Value, 10);
	         Put(Dest, "|");
	         Value := 0;
	         New_Line(Dest);
	      end if;
	   end loop;
   end loop;
   Put(Dest, "=================================================================");
   End Copy;
   --------------------------------------------------------
   --Huvudprogram
   --------------------------------------------------------
   Antal : Natural;
   File1, File2 : File_Type;
   Max_Value : Integer := 0;
   Max_String : String(1..31);
   program : Unbounded_String;

Begin

Antal := argument_count;
Program := To_Unbounded_String(Command_Name);

   if Antal /= 1 then
      Put_Line("felaktigt antal argument!");
      Put("Användning: ");
      Put(Program);
      Put(" FILNAMN.TXT");
   else
      Open(File1, In_File, Argument(1));
      Create(File2, Out_File, "CORRECTED_VIKING_NUMBERS.TXT");
      Put_Line(File2, "|Inläst sträng       |Korrigerat vikingskt tal       |Värde     |");
      Put_Line(File2, "=================================================================");
      Copy(File1, File2, Max_Value, Max_String);
      Close(File1);
      Close(File2);
      Put("Största som heltal: ");
      Put(Max_Value, 0);
      New_Line;
      Put("Största som vikingskt tal: " & (Max_String));
   end if;

end Vikingska_Tal;
