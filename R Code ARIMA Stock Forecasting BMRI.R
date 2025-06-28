## Final Project Metode Peramalan
## Kelompok 5
# Import library yang diperlukan
library(forecast)
library(tseries)
library(MASS)
library(TSA)
library(lmtest)
library(ggplot2)

# Load data
BMRI <- read.csv("C:/Users/LENOVO/Downloads/BMRI.csv")
View(BMRI)

# Lihat sekilas data
head(BMRI)

# Menggunakan kolom close saja
BMRI <- BMRI$Close
BMRI

# Konstruksi variabel time series
timeseries <- ts(BMRI, start = c(2003, 8), frequency = 12)
tsdisplay(timeseries)

# Differencing
differencingts <- diff(timeseries, 1)
BoxCox.ar(timeseries)

# Menentukan parameter Box-Cox (transformasi)
BoxCox.lambda(timeseries)
transformts <- BoxCox(timeseries, BoxCox.lambda(timeseries))

# Differencing setelah transformasi
difftransformts <- diff(transformts, 1)
tsdisplay(transformts)
tsdisplay(difftransformts)

# Melakukan uji
adf.test(difftransformts)

#-----------------------------------------------------------------------------------------
# Spesifikasi model
eacf(difftransformts)

# Evaluasi model berdasarkan hasil EACF 
# Model yang diajukan: 
#ARIMA(0,1,3); ARIMA(2,1,0); ARIMA(3,1,1); ARIMA(3,1,2); ARIMA(4,1,2); ARIMA(5,1,2)
model_1 <- Arima(transformts, order = c(0, 1, 3),include.constant = TRUE)
model_2 <- Arima(transformts, order = c(2, 1, 0),include.constant = TRUE)
model_3 <- Arima(transformts, order = c(3, 1, 1),include.constant = TRUE)
model_4 <- Arima(transformts, order = c(3, 1, 2),include.constant = TRUE)
model_5 <- Arima(transformts, order = c(4, 1, 2),include.constant = TRUE)
model_6 <- Arima(transformts, order = c(5, 1, 2),include.constant = TRUE)

# Menampilkan ringkasan model untuk membandingkan
summary(model_1)
summary(model_2)
summary(model_3)
summary(model_4)
summary(model_5)
summary(model_6)
cbind(model_1, model_2, model_3, model_4,model_5, model_6)

#---------------------------------------------------------------------------------------
# Diagnostik model
# Residual
checkresiduals(model_4)
adf.test(model_4$residuals)

# Normality
jarque.bera.test(model_4$residuals)


# Overfitting ARIMA(3,1,2)
overfit_1 <- Arima(transformts, order = c(4,1,2), include.constant = TRUE)
overfit_2 <- Arima(transformts, order = c(3,1,3), include.constant = TRUE)
coeftest(model_4)
coeftest(overfit_1)
coeftest(overfit_2)

cbind(overfit_1, overfit_2, model_4)

#---------------------------------------------------------------------
# Forecasting
model_forecast <- Arima(timeseries, order = c(3,1,2), include.constant = TRUE,
                   lambda = BoxCox.lambda(timeseries)) 
model_forecast


# Peramalan 5 bulan kedepan
forecast_result <- forecast(model_forecast, h = 5)
autoplot(forecast_result)

# Menampilkan hasil forecast
print(forecast_result)

#----------------------------------------------------------------------------------------

# Cross Validation
# Membagi data menjadi training dan testing
train_end <- length(timeseries) - 12  # Misalnya 12 bulan terakhir sebagai data testing
train <- window(timeseries, end = c(2003 + (train_end %/% 12), train_end %% 12 + 1))
test <- window(timeseries, start = c(2003 + (train_end %/% 12), train_end %% 12 + 2))

# Melatih model ARIMA pada data training
model <- Arima(train, order = c(3, 1, 2), include.constant = TRUE, lambda = BoxCox.lambda(train))

# Menggunakan model untuk meramalkan data testing
forecast_result <- forecast(model, h = length(test))

# Visualisasi hasil peramalan vs data aktual
autoplot(forecast_result) +
  autolayer(test, series = "Actual Values") +
  ggtitle("Peramalan ARIMA(3,1,2) melalui Data Training - Testing") 
  xlab("Periode") +
  ylab("Harga Saham") +
  scale_color_manual(values = c("Actual Values" = "red", "Fitted Values" = "blue")) +
  theme_minimal() +
  theme(legend.title = element_blank())

# Menampilkan hasil forecast dan data aktual
print(cbind(Actual = test, Forecast = forecast_result$mean))

#---------------------------------------------------------------------------------------------

