        ORG 0000H
        LJMP MAIN
		
        ORG 0030H
MAIN:   MOV P1,#00H
        MOV DPTR,#200H
A1:     MOV P1,#24H
        MOV P0,#11H
        MOV P2,#0A4H
        
        MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#0F9H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#40H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H


B1:     MOV P1,#14H
        MOV P0,#0CH
        MOV P2,#00H
        MOV P3,#00H
       MOV P2,#0A4H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#0F9H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#40H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H

C1:     MOV P1,#0AH
        MOV P0,#24H
        MOV P2,#0A4H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#0F9H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
        MOV P2,#40H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H

D1:     MOV P1,#21H
        MOV P0,#22H
        MOV P2,#0A4H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#0F9H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         MOV P2,#40H
        
         MOV P3,#90H
        ACALL DELAY
         MOV P3,#80H
        ACALL DELAY
         MOV P3,#0F8H
        ACALL DELAY
         MOV P3,#82H
        ACALL DELAY
         MOV P3,#92H
        ACALL DELAY
         MOV P3,#99H
        ACALL DELAY
         MOV P3,#0B0H
        ACALL DELAY
         MOV P3,#0A4H
        ACALL DELAY
         MOV P3,#0F9H
        ACALL DELAY
          MOV P3,#40H
         LJMP MAIN
		 
DELAY:  MOV R4,#50
H3:     MOV R5,#20H
H2:     MOV R6,#0FFH
H1:     DJNZ R6,H1
        DJNZ R5,H2
        DJNZ R4,H3
        RET    
END		
          