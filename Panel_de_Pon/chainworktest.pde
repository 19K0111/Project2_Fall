import java.io.File;
import java.util.ArrayList;
import java.util.Scanner;

public void chainworktest() {
    ArrayList<String> stack = new ArrayList<String>();
    File file = new File("C:\\Users\\admin\\Desktop\\課題\\2020年度\\秋学期\\プロジェクト\\src\\Panel_de_Pon\\chains-test.pdp");
    Scanner scanner = null;
    try {
        scanner = new Scanner(file, "UTF-8");
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            if (!line.startsWith("//") && !line.equals("")) {
                stack.add(line);
            }
        }
    } catch (Exception ex) {
        System.out.println(ex);
    } finally {
        if (scanner != null) {
            scanner.close();
        }
    }
    for (int i = 0; i < stack.size(); i++) {
        for (int j = 0; j < stack.get(i).length(); j++) {
            cells_img[i][j] = panels[((int) stack.get(stack.size() - 1 - i).charAt(j)) - 48];
            cells_type[i][j] = ((int) stack.get(stack.size() - 1 - i).charAt(j)) - 48;

        }
    }
    // for (int y = cells.length - 1; y >= 0; y--) {
    //     for (int x = 0; x < cells[0].length; x++) {
    //         System.out.print(cells[y][x]);
    //     }
    //     System.out.println();
    // }
}
