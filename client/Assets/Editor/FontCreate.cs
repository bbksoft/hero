using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Xml;
using UnityEngine.UI;

static public class FontCreate {

    [MenuItem("MyTools/Create font", false, 1)]
    static public void Create()
    {
        foreach (Object o in Selection.GetFiltered(typeof(Object), SelectionMode.DeepAssets))
        {
            string assetFile = AssetDatabase.GetAssetPath(o);

            XmlDocument xmldoc = new XmlDocument();
            xmldoc.Load(assetFile);

            var root = xmldoc.DocumentElement;
            var common = root.SelectSingleNode("common");
            var chars = root.SelectSingleNode("chars");


            string fontPathName = assetFile.Substring(0, assetFile.Length - 3) + "fontsettings";

            Font font = (Font)AssetDatabase.LoadAssetAtPath(assetFile, typeof(Font));
            if (font == null)
            {
                font = new Font();
                AssetDatabase.CreateAsset(font, fontPathName);
            }  

            float texWidth = int.Parse(common.Attributes["scaleW"].Value);
            float texHeight = int.Parse(common.Attributes["scaleH"].Value);

            var list = chars.ChildNodes;
            var infos = new CharacterInfo[list.Count];
            for (int i=0; i<list.Count; i++)
            {
                var charData = list[i];

                CharacterInfo info = new CharacterInfo();
                info.index =  int.Parse(charData.Attributes["id"].Value);

                int x = int.Parse(charData.Attributes["x"].Value);
                int y = int.Parse(charData.Attributes["y"].Value);
                int width = int.Parse(charData.Attributes["width"].Value);
                int height = int.Parse(charData.Attributes["height"].Value);
                int xadvance = int.Parse(charData.Attributes["xadvance"].Value);

                info.uvTopLeft = new Vector2(x / texWidth, 1 - y / texWidth);
                info.uvBottomRight = info.uvTopLeft + new  Vector2(width / texWidth, -height / texWidth);

                info.minX = 0;
                info.minY = -height;
                info.maxX = width;
                info.maxY = 0;

                info.advance = xadvance;

                infos[i] = info;
            }

           
            font.characterInfo = infos;

            AssetImporter importer = AssetImporter.GetAtPath(assetFile);           
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
}
