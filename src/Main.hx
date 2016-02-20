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
        
        var path    = 'bin/Snippets';
        var out     = 'bin/new-Snippets'; 
        var vscode  = 'bin/vscode'; 
		
        if(!FileSystem.exists(path)) FileSystem.createDirectory(path);
        if(!FileSystem.exists(out)) FileSystem.createDirectory(out);
        if(!FileSystem.exists(vscode)) FileSystem.createDirectory(vscode);
        
        if(sys.FileSystem.exists(path))
		{
            var haxejson = '\n\n/* \nThis is a converted list of haxe-sublime-bundle snippets created by Clément Charmet.\nhttps://github.com/clemos/haxe-sublime-bundle/tree/master/Snippets\n*/\n\n\n';
            var readme = '| shortcut | description |\n| --- | --- |\n';
            
            var list :Array<String> = FileSystem.readDirectory(path);
            for (i in 0...list.length)
            {
                var _filename = list[i].split('.')[0];

                var xml : Xml = Xml.parse(File.getContent(path + '/' + list[i]));
                
                var fast = new haxe.xml.Fast(xml.firstElement());
                var content = fast.node.content;
                var tabTrigger = fast.node.tabTrigger;
                var description = fast.node.description;
                
                readme += '| ${tabTrigger.innerData} | ${description.innerData} |\n';

                // trace(tabTrigger.innerData); 
                // trace(description.innerData);
                
                var _content = content.innerData
                                .replace(":$TM_SELECTED_TEXT",":// your code")
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
                                ;
                                
                var contentArr : Array<String> = _content.split("\n");
                var __cont = '';
                for (i in 0...contentArr.length){
                    __cont += '"' + contentArr[i] + '" ,';
                }              

                var json  = '"$_filename" : {\n\t"prefix":"${tabTrigger.innerData}", \n\t"body":[${__cont}], \n\t"description":"${description.innerData}"\n}';
                
                haxejson += json;
                haxejson += ',\n\n';
                
                var _filePath = out + '/' + _filename + '.json';
                var f:FileOutput = File.write(_filePath,false);
                f.writeString('{\n' + json + '\n}');
                f.close();
                
            }
            
            var _filePath = vscode + '/haxe.json';
            var f:FileOutput = File.write(_filePath,false);
            f.writeString('{\n' + haxejson + '\n}');
            f.close();
            
            var _filePath = vscode + '/shortcuts.md';
            var f:FileOutput = File.write(_filePath,false);
            f.writeString(readme);
            f.close();
            
            
		}
	}

	
	
    static public function main()
    {
       var main = new Main();
	}
}

