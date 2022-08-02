%% 
clc,clear
%% 
cam = webcam('HP HD Camera');%Burada kameramızı aktif hale getirerek görüntü okutma işlemi
detector=yolov4ObjectDetector("csp-darknet53-coco")%hazır eğitilmiş ağ olan yolov4 ve çoğu nesnenin içinde bulunduğu coco veri seti kullanıldı.
a=843252.4645;
b=0.465731406;
c=8.78426E-14;
d=-0.304288297;
%yukarıda belirtilen değişkenlerin her biri referans noktası parametresi
%olarak atandı.
f = figure;
NET.addAssembly('System.Speech');%görüntü ve uzaklık bilgilerinin sistem tarafından sesli okutulması sağlandı.
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
while ishandle(f)%Döngü boyunca belirlenen parametreler regresyon çarpımına tabi tutularak bir linner sonuç elde edilebilmek adına uzaklık değerininde tespit edilmesinde kullanıldı.
%img=imread("oda.jpeg");    
    img = snapshot(cam);
    [bbox,score,label] = detect(detector,img);
    for i = 1 : size(bbox, 1)
        areaBbox(i) = abs((bbox(i,4)-bbox(i,1))*(bbox(i,3)-bbox(i,2)));
        areaImg = size(img,1)*size(img,2);
        oran(i) = areaBbox(i)/areaImg;
        uzaklik(i)=d+(a-d)/(1+(oran(i)/c)^b);
        %dist = 21.1/oran;
        str=string(label(i))
        strU=string(uzaklik(i))
        defaultString= strcat(str,' at', strU,' meters')
       
%         NET.addAssembly('System.Speech');
%         obj = System.Speech.Synthesis.SpeechSynthesizer;
%         obj.Volume = 100;
        Speak(obj, defaultString);
        annotation = sprintf('%s%.2f %s  %.2fm', '%',  score(i)*100, label(i), uzaklik(i));
        img = insertObjectAnnotation(img, 'rectangle', bbox(i,:), annotation);
    end
    image(img)
    drawnow
    pause(3)%Burada ise belirli zaman aralıkarında kamera kesmeye uğratıldı sebebi ise sistemin sesli bir şekilde görüntü ve uzaklık bilgisini okurken sıradaki görüntü ile çakışmaması adına.
end
clear cam