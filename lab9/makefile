OPENCV := -lopencv_core -lopencv_imgcodecs -lopencv_imgproc

run: ./app.exe
	@file img.png
	@echo ""
	./app.exe

app.exe: main.o
	g++ $< -o $@ $(OPENCV)

*.o : *.cpp
	g++ -std=c++20 -Wall -Werror -g3 -c $< -o $@ $(OPENCV)

clean:
	rm -rf ./*.o ./*.exe res_img.png