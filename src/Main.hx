package ;


import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

using StringTools;

/**
 * @author Matthijs Kamstra  aka [mck]
 * MIT
 * http://www.matthijskamstra.nl
 */
class Main
{
	public function new()
	{
        
        var path = 'bin/Snippets';
        var out = 'bin/new-Snippets';
		
        if(sys.FileSystem.exists(path))
		{
            var haxejson = '';
            var list :Array<String> = FileSystem.readDirectory(path);
            for (i in 0...list.length)
            {
                // trace(list[i]);

                var _filename = list[i].split('.')[0];

                var xml : Xml = Xml.parse(File.getContent(path + '/' + list[i]));
                
                var fast = new haxe.xml.Fast(xml.firstElement());
                var content = fast.node.content;
                var tabTrigger = fast.node.tabTrigger;
                var description = fast.node.description;
                
                if(!FileSystem.exists(out)) FileSystem.createDirectory(out);

                // trace(tabTrigger.innerData);
                // trace(description.innerData);
                
                var _content = content.innerData
                                .replace("${5:$HX_W_OCB", "")
                                .replace("$HX_W_OCB"," ")
                                .replace("$HX_K_W_ORB"," ")
                                .replace("$HX_ORB_W"," ")
                                .replace("$HX_W_CRB"," ")
                                .replace("$HX_W_OCB"," ")
                                .replace("$HX_W_ORB"," ")
                                .replace("$HX_W_C"," ")
                                .replace("$HX_W_TD"," ")
                                .replace("$HX_TD_W", " ")
                                .replace("$HX_C_W"," ")
                                .replace("$HX_W_A"," ")
                                .replace("${HX_A_W}" , " ")
                                .replace("$HX_A_W", " ")
                                .replace("${HX_CCB_W}", " ")
                                .replace("\\}}", "}")
                           
                                .replace("}}", "}")
                        
                                .replace("${2:${3", "${3")
                                .replace("\\}", "")
                                .replace(":$TM_SELECTED_TEXT}$0","}")
                                .replace(":$TM_SELECTED_TEXT",":TM_SELECTED_TEXT");


                var json  = '"$_filename" : {\n\t"prefix":"${tabTrigger.innerData}", \n\t"body":"${_content}", \n\t"description":"${description.innerData}"\n}';
                
                haxejson += json;
                haxejson += ',\n\n';
                
                var _filePath = out + '/' + _filename + '.json';
                var f:FileOutput = File.write(_filePath,false);
                f.writeString(json);
                f.close();
                
            }
            
                var _filePath = out + '/haxe.json';
                var f:FileOutput = File.write(_filePath,false);
                f.writeString('{\n' + haxejson + '\n}');
                f.close();
            
            
		}
	}

	
	
    static public function main()
    {
       var main = new Main();
	}
}

