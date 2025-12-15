with Ada.Text_IO; use Ada.Text_IO;

procedure Ada_CGI is
begin
   Put_Line ("Content-Type: text/plain");
   New_Line;
   Put_Line ("Hello from Ada CGI!");
end Ada_CGI;
