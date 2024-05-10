#include <opencv2/opencv.hpp>
#include <cstdint>
#include <emmintrin.h>

#include <iostream>

#define INPUT_FILE "img1.png"
#define OUTPUT_FILE "res_img.png"


const uint8_t chng = 200;
const uint8_t arr_chng[16] = {chng, chng, chng, chng, chng, chng, chng, chng, 
                                chng, chng, chng, chng, chng, chng, chng, chng};

void bright_img(uint8_t *img_data, size_t len)
{
    // uint8_t chng = 110;
    // for (size_t i = 0; i < len; ++i)
    // {
    //     // if (img_data[i] + chng >= 255)
    //     //     img_data[i] = 255;
    //     // else
    //     //     img_data[i] += chng;

    // }


    for (size_t i = 2110; i < 2115; ++i)
        std::cout << unsigned(img_data[i]) << " ";
    std::cout << std::endl;
    
    for (size_t i = 0; i < len; i += 16)
    {
        __asm__(
            // ".intel_syntax noprefix\n\t"
            "movdqa (%[data]), %%xmm0       \n\t"   // a - alignas
            "movdqu (%[arr_chng]), %%xmm1   \n\t"
            "paddusb  %%xmm1, %%xmm0          \n\t" //  сложение беззнаковых байтов в 16 дорожках, засчет арифметики насыщения -
            "movdqa %%xmm0 , (%[data])      \n\t"   //  переполнение усекается до максимально возможного значения, которое может выдержать размер инструкции
            : 
            : [data] "r" (img_data + i), [arr_chng] "r" (arr_chng)
            : "%xmm0", "%xmm1"
        );
    }    

    for (size_t i = 2110; i < 2115; ++i)
        std::cout << unsigned(img_data[i]) << " ";
    std::cout << std::endl;

    for (size_t i = len - len % 16; i < len; ++i)
    {
        img_data[i] += chng;
    }
}


int main(int argc, char** argv) {
    // Create a container
    cv::Mat img; 

    // Create an mat iterator
    cv::MatIterator_<cv::Vec3b> it;

    // Read the image in color format
    // CV_8UC3 для 8-битных трехканальных цветных изображений;
    img = cv::imread(INPUT_FILE, 1);
    if(!img.data) {
        std::cout << "Error: the image wasn't correctly loaded." << std::endl;
        return -1;
    }

    size_t img_size = img.rows * img.cols;
    alignas(16) uint8_t *img_data = static_cast<uint8_t*>(malloc(img_size * 3));
    if (!img_data)
    {
        std::cerr << "Error: allocate memory\n";
        return -1;
    }

    // iterate through each pixel
    size_t ind = 0;
    for(it = img.begin<cv::Vec3b>(); it != img.end<cv::Vec3b>(); ++it)
    {
        for (size_t i = 0; i < 3; ++i)
        {
            img_data[ind] = (*it)[i];
            ++ind;
        }

    }
    // std::cout << "ind =      " << ind  << std::endl;
    // std::cout << "img_size = " << img_size << std::endl;
    // std::cout << "diff =     " << img.end<cv::Vec3b>() - img.begin<cv::Vec3b>() << std::endl;

    bright_img(img_data, img_size * 3);

    ind = 0;
    for(it = img.begin<cv::Vec3b>(); it != img.end<cv::Vec3b>(); ++it)
    {
        for (size_t i = 0; i < 3; ++i)
        {
            (*it)[i] = img_data[ind];
            ++ind;
        }
    }

    free(img_data);

    cv::imwrite(OUTPUT_FILE, img);

    return 0;
}