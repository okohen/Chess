with  ada.Text_IO;
use  ada.Text_IO;

package body pack_piece is
   ------------------------------------------------------------------------
 procedure afficherpos(p:tcase) is
   begin
      put(Integer'Image(p.posx));
      put(Integer'Image(p.posy));
   end afficherpos;
   ------------------------------------------------------------------------
   procedure affichercase(tfpiece:in T_fileCasePossibles) is
   begin
      put('('&Integer'Image(tfpiece.casePossible.posx)&','&Integer'Image(tfpiece.casePossible.posy)&" ) ");
   end affichercase;

   -----------------------------------------------------------------------
   --     procedure afficherpiece(p:in out t_piece) is
--     begin
--        New_Line;
--        put(t_valeur'Image(p.valeur));
--        New_Line;
--        put(t_couleur'Image(p.couleur));
--        New_Line;
--        put(Integer'image(p.Position.posx)&Integer'Image(p.position.posy));
--        New_Line;
--        put("Haut :");
--        while filepleine(p.haut) loop
--        afficherpos(deplacement.filelire(p.haut));put("//");
--        deplacement.defiler(p.haut);
--        end loop;
--        put("Haut :");
--        while filepleine(p.bas) loop
--        afficherpos(deplacement.filelire(p.bas));put("//");
--        deplacement.defiler(p.bas);
--        end loop;
--
--     end afficherpiece;


end pack_piece;
